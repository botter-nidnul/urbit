import React, { useEffect, ReactNode } from 'react';
import {
  Switch,
  Route,
  RouteComponentProps
} from 'react-router-dom';
import { Col, Box, Text } from '@tlon/indigo-react';
import _ from 'lodash';
import Helmet from 'react-helmet';

import { AppName } from '@urbit/api';

import { Resource } from './Resource';
import { PopoverRoutes } from './PopoverRoutes';
import { Skeleton } from './Skeleton';
import { InvitePopover } from './InvitePopover';
import { NewChannel } from './NewChannel';

import GlobalApi from '~/logic/api/global';
import { StoreState } from '~/logic/store/type';
import { UnjoinedResource } from '~/views/components/UnjoinedResource';
import { useLocalStorageState } from '~/logic/lib/useLocalStorageState';
import { Loading } from '~/views/components/Loading';

import '~/views/apps/links/css/custom.css';
import '~/views/apps/publish/css/custom.css';
import { getGroupFromWorkspace } from '~/logic/lib/workspace';
import { GroupHome } from './Home/GroupHome';
import { Workspace } from '~/types/workspace';

type GroupsPaneProps = StoreState & {
  baseUrl: string;
  workspace: Workspace;
  api: GlobalApi;
};

export function GroupsPane(props: GroupsPaneProps) {
  const { baseUrl, associations, groups, contacts, api, workspace } = props;
  const relativePath = (path: string) => baseUrl + path;
  const groupPath = getGroupFromWorkspace(workspace);

  const groupContacts = Object.assign({}, ...Array.from(groups?.[groupPath]?.members ?? []).filter(e => contacts[`~${e}`]).map(e => {
      return {[e]: contacts[`~${e}`]};
  })) || {};
  const rootIdentity = contacts?.["/~/default"]?.[window.ship];
  const groupAssociation =
    (groupPath && associations.groups[groupPath]) || undefined;
  const group = (groupPath && groups[groupPath]) || undefined;
  const [recentGroups, setRecentGroups] = useLocalStorageState<string[]>(
    'recent-groups',
    []
  );

  useEffect(() => {
    if (workspace.type !== 'group') {
      return;
    }
    setRecentGroups(gs => _.uniq([workspace.group, ...gs]));
  }, [workspace]);

  if (!(associations && (groupPath ? groupPath in groups : true))) {
    return null;
  }

  const popovers = (routeProps: RouteComponentProps, baseUrl: string) =>
     ( <>
        {groupPath && ( <PopoverRoutes
          contacts={groupContacts || {}}
          rootIdentity={rootIdentity}
          association={groupAssociation!}
          group={group!}
          api={api}
          storage={props.storage}
          notificationsGroupConfig={props.notificationsGroupConfig}
          associations={associations}

          {...routeProps}
          baseUrl={baseUrl}
                        />)}
        <InvitePopover
          api={api}
          association={groupAssociation!}
          baseUrl={baseUrl}
          groups={props.groups}
          contacts={props.contacts}
          workspace={workspace}
        />
      </>
    );

  return (
    <Switch>
      <Route
        path={[relativePath('/resource/:app/(ship)?/:host/:name')]}
        render={(routeProps) => {
          const { app, host, name } = routeProps.match.params as Record<
            string,
            string
          >;

          const appName = app as AppName;

          const resource = `/ship/${host}/${name}`;
          const association = associations.graph[resource];
          const resourceUrl = `${baseUrl}/resource/${app}${resource}`;

          if (!association) {
            return <Loading />;
          }

          return (
            <Skeleton
              mobileHide
              recentGroups={recentGroups}
              selected={resource}
              selectedApp={appName}
              {...props}
              baseUrl={resourceUrl}
            >
              <Resource
                {...props}
                {...routeProps}
                association={association}
                baseUrl={baseUrl}
              />
              {popovers(routeProps, resourceUrl)}
            </Skeleton>
          );
        }}
      />
      <Route
        path={relativePath('/join/:app/(ship)?/:host/:name')}
        render={(routeProps) => {
          const { app, host, name } = routeProps.match.params;
          const appPath = `/ship/${host}/${name}`;
          const association = associations.graph[appPath];
          const resourceUrl = `${baseUrl}/join/${app}${appPath}`;
          let title = groupAssociation?.metadata?.title ?? 'Landscape';

          if (!association) {
            return <Loading />;
          }

          title += ` - ${association.metadata.title}`;
          return (
            <>
              <Helmet defer={false}>
                <title>{props.notificationsCount ? `(${String(props.notificationsCount)}) ` : ''}{ title }</title>
              </Helmet>
              <Skeleton
                recentGroups={recentGroups}
                mobileHide
                selected={appPath}
                {...props}
                baseUrl={baseUrl}
              >
                <UnjoinedResource
                  graphKeys={props.graphKeys}
                  notebooks={props.notebooks}
                  inbox={props.inbox}
                  baseUrl={baseUrl}
                  api={api}
                  association={association}
                />
                {popovers(routeProps, resourceUrl)}
              </Skeleton>
            </>
          );
        }}
      />
      <Route
        path={relativePath('/new')}
        render={(routeProps) => {
          const newUrl = `${baseUrl}/new`;
          return (
            <Skeleton mobileHide recentGroups={recentGroups} {...props} baseUrl={baseUrl}>
              <NewChannel
                {...routeProps}
                api={api}
                baseUrl={baseUrl}
                associations={associations}
                groups={groups}
                group={groupPath}
                contacts={props.contacts}
                workspace={workspace}
              />
              {popovers(routeProps, baseUrl)}
            </Skeleton>
          );
        }}
      />
      <Route
        path={[relativePath('/'), relativePath('/feed')]}
        render={(routeProps) => {
          const shouldHideSidebar =
            routeProps.location.pathname.includes('/feed');
          const title = groupAssociation?.metadata?.title ?? 'Landscape';
          return (
            <>
              <Helmet defer={false}>
                <title>{props.notificationsCount ? `(${String(props.notificationsCount)}) ` : ''}{ title }</title>
              </Helmet>
              <Skeleton
                mobileHide={shouldHideSidebar}
                recentGroups={recentGroups}
                baseUrl={baseUrl}
                {...props}>
                <GroupHome 
                  {...routeProps}
                  api={api}
                  baseUrl={baseUrl}
                  associations={associations}
                  groups={groups}
                  groupPath={groupPath}
                  contacts={props.contacts}
                  workspace={workspace}
                />
                {popovers(routeProps, baseUrl)}
              </Skeleton>
            </>
          );
        }}
      />
    </Switch>
  );
}
